SP_FILE="./trgt/test_myappauth.json"
SP_ID=$(jq -r '.clientId' $SP_FILE)

# Define the expected value based on your test JSON file
EXPECTED_SP_ID="000-111-tcid-222-333"

if [ "$SP_ID" = "$EXPECTED_SP_ID" ]; then
    echo "Test Passed: SP_ID is correctly extracted as $SP_ID"
else
    echo "Test Failed: SP_ID extraction returned $SP_ID"
fi
