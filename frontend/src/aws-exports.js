// frontend/src/aws-exports.js
const awsExports = {
  Auth: {
    region: process.env.VUE_APP_REGION,
    userPoolId: process.env.VUE_APP_USER_POOL_ID,
    userPoolWebClientId: process.env.VUE_APP_CLIENT_ID,
    authenticationFlowType: 'USER_PASSWORD_AUTH',
  },
  API: {
    endpoints: [
      {
        name: 'stocksApi',
        endpoint: 'https://your-api-id.execute-api.us-east-1.amazonaws.com/prod',
        region: process.env.VUE_APP_REGION,
      },
      {
        name: 'wishlistApi',
        endpoint: 'https://your-api-id.execute-api.us-east-1.amazonaws.com/prod',
        region: process.env.VUE_APP_REGION,
      },
    ],
  },
};

export default awsExports;
