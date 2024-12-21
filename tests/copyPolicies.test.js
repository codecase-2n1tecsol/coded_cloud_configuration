const { fetchPolicies, savePolicies } = require('../interactiveConditionalAccessPolicies');
const fs = require('fs');
jest.mock('fs');

test('fetchPolicies retrieves policies based on filter', async () => {
    const mockClient = {
        api: jest.fn(() => ({
            get: jest.fn().mockResolvedValue({ value: [{ id: 'test-policy' }] }),
        })),
    };
    const policies = await fetchPolicies.call(mockClient, 'Status: On');
    expect(policies).toHaveLength(1);
    expect(policies[0].id).toBe('test-policy');
});

test('savePolicies writes policies to files', async () => {
    const mockPolicies = [{ id: 'test-policy', name: 'Test Policy' }];
    await savePolicies(mockPolicies);
    expect(fs.writeFileSync).toHaveBeenCalledWith(
        'policy_test-policy.json',
        JSON.stringify(mockPolicies[0], null, 2)
    );
});
