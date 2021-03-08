const https = require('https');
const querystring = require('querystring');
const AWS = require('aws-sdk');
AWS.config.update({region: 'us-east-1'});

function createPostData() {
  const jsonData = {
    person: {
      dob:"1985-03-18",
      gender:"M",
      nyresident:"Y",
      nyworker:"Y",
      address: {
        zip:"10009"
      },
      acknowledge: true,
      name:""
    }
  };
  return JSON.stringify(jsonData);
}

exports.handler = (event) => {
    const postData = createPostData();
    const options = {
      hostname:  'am-i-eligible.covid19vaccine.health.ny.gov',
      path: '/api/submit',
      method: 'POST',
      headers: {
        'Content-Type': "application/json;charset=UTF-8",
        'Content-Length': postData.length
      }
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
          if (json.status === 'approved') {
            console.log('APPROVED!!');
          } else {
            console.log('NoT Approved!!');
          }
        } catch(e) {
          console.error('Error occurred while running CovidVaccine Eligibility lambda');
        }
      });
    });

    req.on('error', error => {
      console.error(error);
    });

    req.write(postData);
    req.end();
};

