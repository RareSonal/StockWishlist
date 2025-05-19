const awsExports = {
  Auth: {
    region: 'us-east-1', // your region
    userPoolId: 'us-east-1_XXXXXXXXX',
    userPoolWebClientId: 'xxxxxxxxxxxxxxxxxxxxxxxxxx',
    authenticationFlowType: 'USER_PASSWORD_AUTH',
  },
  API: {
    endpoints: [
      {
        name: 'stocksApi',
        endpoint: 'https://your-api-id.execute-api.us-east-1.amazonaws.com/prod',
        region: 'us-east-1',
      },
      {
        name: 'wishlistApi',
        endpoint: 'https://your-api-id.execute-api.us-east-1.amazonaws.com/prod',
        region: 'us-east-1',
      },
    ],
  },
};

export default awsExports;
