// This will create an Enterprise App (client) in Entra Apps, and assign RBAC Roles.

const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");
const inquirer = require("inquirer");
const { Client } = require("@microsoft/microsoft-graph-client");
require("isomorphic-fetch");
const { ConfidentialClientApplication } = require("@azure/msal-node");
require("dotenv").config();

// Load secrets from environment variables
const config = {
  clientId: process.env.CLIENT_ID,
  clientSecret: process.env.CLIENT_SECRET,
  tenantId: process.env.TENANT_ID,
  subscriptionId: process.env.SUBSCRIPTION_ID,
};

// Validate environment variables
if (!config.clientId || !config.clientSecret || !config.tenantId || !config.subscriptionId) {
  throw new Error("Missing required environment variables (CLIENT_ID, CLIENT_SECRET, TENANT_ID, SUBSCRIPTION_ID)");
}

const msalConfig = {
  auth: {
    clientId: config.clientId,
    authority: `https://login.microsoftonline.com/${config.tenantId}`,
    clientSecret: config.clientSecret,
  },
};

const cca = new ConfidentialClientApplication(msalConfig);

async function getAccessToken() {
  const tokenRequest = {
    scopes: ["https://graph.microsoft.com/.default"],
  };

  const response = await cca.acquireTokenByClientCredential(tokenRequest);
  return response.accessToken;
}

function saveToFile(data, fileName = "myappauth.json") {
  const dirPath = path.join(__dirname, "../../dataReturns/sensitiveFiles");
  const filePath = path.join(dirPath, fileName);

  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }

  fs.writeFileSync(filePath, JSON.stringify(data, null, 2));
  console.log(`Saved to ${filePath}`);
}

function saveToEnv(data) {
  const envPath = path.join(__dirname, "../../.env");

    // Prepare the data as `key=value` pairs
  const envContent = Object.entries(data)
    .map(([key, value]) => `${key}=${value}`)
    .join("\n");

    // Write or append to the .env file
  fs.writeFileSync(envPath, envContent, { encoding: "utf8" });
  console.log(`Environment variables saved to ${envPath}`);
}

async function createEnterpriseAppAndServicePrincipal() {
  try {
    const accessToken = await getAccessToken();

    const graphClient = Client.init({
      authProvider: (done) => done(null, accessToken),
    });

    const appDetails = { displayName: "Orch_client" };
    const appResponse = await graphClient.api("/applications").post(appDetails);
    console.log("Application Created:", appResponse);

    const servicePrincipalDetails = { appId: appResponse.appId };
    const spResponse = await graphClient.api("/servicePrincipals").post(servicePrincipalDetails);
    console.log("Service Principal Created:", spResponse);

    const appAuthData = {
      CLIENT_ID: appResponse.appId,
      CLIENT_SECRET: config.clientSecret,
      TENANT_ID: config.tenantId,
      SUBSCRIPTION_ID: config.subscriptionId, // Replace with logic if needed
    };

    saveToFile(appAuthData); // Save JSON file
    saveToEnv(appAuthData); // Save to .env file

    return spResponse.id;
  } catch (error) {
    console.error("Error creating Enterprise App or Service Principal:", error.message);
    throw error;
  }
}

async function promptForRBAC() {
  const answers = await inquirer.prompt([
    {
      type: "confirm",
      name: "assignRBAC",
      message: "Would you like to assign RBAC roles at this time?",
      default: false,
    },
  ]);

  if (answers.assignRBAC) {
    try {
      console.log("Calling the assign_rbac.sh script...");
      execSync("bash /usr/src/projectSpace/coded_cloud_configuration/scripts/cloudSetup_phase/.assign_rbac.sh", {
        stdio: "inherit",
      });
      console.log("RBAC roles assigned successfully.");
    } catch (error) {
      console.error("Error while assigning RBAC roles:", error.message);
    }
  } else {
    console.log("Skipping RBAC role assignment.");
  }
}

async function main() {
  try {
    const spId = await createEnterpriseAppAndServicePrincipal();
    console.log(`Service Principal ID: ${spId}`);
    await promptForRBAC();
  } catch (error) {
    console.error("Error:", error);
  }
}

if (require.main === module) {
  main();
}
