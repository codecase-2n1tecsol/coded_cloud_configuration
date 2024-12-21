// copyConditionalAccessPolicies.js

const fs = require('fs');
const { Client } = require('@microsoft/microsoft-graph-client');
require('isomorphic-fetch'); // Required for the Graph client
require('dotenv').config(); // Load environment variables

// Initialize the Microsoft Graph client
const client = Client.init({
    authProvider: (done) => {
        const accessToken = process.env.GRAPH_ACCESS_TOKEN;
        if (!accessToken) {
            done(new Error('Missing Microsoft Graph access token'), null);
            return;
        }
        done(null, accessToken);
    },
});

async function fetchAndSavePolicies() {
    try {
        const response = await client.api('/conditionalAccess/policies').get();
        const policies = response.value;

        policies.forEach(policy => {
            const fileName = `policy_${policy.id}.json`;
            fs.writeFileSync(fileName, JSON.stringify(policy, null, 2));
            console.log(`Policy saved to ${fileName}`);
        });
    } catch (error) {
        console.error('Error fetching Conditional Access Policies:', error);
    }
}

fetchAndSavePolicies();
