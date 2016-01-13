# notificaption

The notificaption service takes screenshots of failing checks in Emissary to be sent with notifications. Screenshots result in a more consistent appearance across notification mediums (Slack vs. email). 

## API
### `POST /screenshot`
Screenshots can be generated by `POST`ing data on a failing check to the `/screenshot` endpoint. [This gist](https://gist.github.com/doeg/00ce3ce7dacf6bce570e) contains an example request. In return, you'll receive an S3 URL to the generated image. 

### `GET /health`
Returns an empty response with a 200 status code, when operating normally. Used for AWS health checks. 

## Local development
1. Add your AWS credentials to your environment: ` export AWS_ACCESS_KEY_ID='AKID'; export AWS_SECRET_ACCESS_KEY='SECRET'`
1. Install the dependencies: `npm install`
1. Start up the server: `npm start`. (You can also use `nodemon server.js`, although this might spawn a ton of Electron subprocesses.)
1. Check `http://localhost:9099` to make sure it's up.
1. Make sure you have Emissary running. You can adjust the host, port, and the like for your Emissary service by editing the config file you're using, found in the `config/` folder. 
1. Start screenshotting by `POST`ing to `http://localhost:9099/screenshot`. 

## Deployment
1. Build the Docker image and push it to quay.io: `npm run docker-publish`
1. From the [`compute` repo](https://github.com/opsee/compute): `./run deploy production notificaption latest`

### Troubleshooting deploys
All notificaption logs show up in [Papertrail](https://papertrailapp.com/groups/1993213/events?q=notificaption).

If the service is failing, make sure notificaption is playing nice with Docker by running it locally:

1. `docker build -t quay.io/opsee/notificaption .`
1. `docker run -p 9099:9099 -d quay.io/opsee/notificaption`
1. Get the IP address of the local docker-machine: `docker-machine ip default` (e.g., 123.4.5.6)
1. Try hitting `123.4.5.6:9099`
