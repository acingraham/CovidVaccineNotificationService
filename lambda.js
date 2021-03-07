const https = require('https');
const AWS = require('aws-sdk');
AWS.config.update({region: 'us-east-1'});

exports.handler = (event) => {
    const options = {
      hostname:  'am-i-eligible.covid19vaccine.health.ny.gov',
      path: '/api/list-providers',
      method: 'GET'
    };
    
    const req = https.request(options, res => {
      console.log(`statusCode: ${res.statusCode}`);

      let result = '';
      res.on('data', d => {
        result += d;
      });

      res.on('end', () => {
        try {
          const json = JSON.parse(result);
          const providerNames = ['SUNY Stony Brook University Innovation and Discovery Center'];
          const availableProviders = json.providerList.filter(p => p.availableAppointments !== 'NAC' && providerNames.includes(p.providerName));
          if (availableProviders.length) {
            console.log('Available providers found');
            console.log(availableProviders);
            const textMessage = `COVID ALERT. Appointments available at ${availableProviders.map(p => p.providerName).join(', ')}. Visit https://am-i-eligible.covid19vaccine.health.ny.gov/ to sign up.`
            text(textMessage);
          } else {
            console.log('No available providers');
          }
        } catch(e) {
          text('Error occurred while running CovidVaccine Notification lambda');
        }
      });
    });

    req.on('error', error => {
      console.error(error);
      text('Error occurred while running CovidVaccine Notification lambda');
    });

    req.end();
};

function text(message) {
  const params = {
    Message: message,
    PhoneNumber: '+15555555555',
  };

  const publishTextPromise = new AWS.SNS({apiVersion: '2010-03-31'}).publish(params).promise();

  publishTextPromise.then(
    function(data) {
      console.log('MessageID is ' + data.MessageId);
      console.log(data);
    }).catch(
      function(err) {
      console.error(err, err.stack);
    }); 
}
