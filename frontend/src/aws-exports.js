// frontend/src/aws-exports.js

const apiBase = (process.env.VUE_APP_API_BASE || '').replace(/\/+$/, ''); 

const awsExports = {
  Auth: {
    region: process.env.VUE_APP_REGION || 'us-east-1',
    userPoolId: process.env.VUE_APP_USER_POOL_ID || '',
    userPoolWebClientId: process.env.VUE_APP_CLIENT_ID || '',
    authenticationFlowType: 'USER_PASSWORD_AUTH',
  },
  API: {
    endpoints: [
      {
        name: 'backendApi',
        endpoint: `${apiBase}/v1`, 
        region: process.env.VUE_APP_REGION || 'us-east-1',
      },
    ],
  },
};

export default awsExports;
