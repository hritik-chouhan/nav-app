# Dashboard Navigation application

A Flutter based car IVI dashboard navigation application made for AGL connected with KUKSA.VAL server and used Mapbox API.

## Screenshot


To run this app, we need Flutter SDK, KUKSA server and config.YAML file

#Steps to run the app

- Run KUSKA.VAL server. For more details, checkout [KUKSA.VAL](https://github.com/eclipse/kuksa.val/tree/master/kuksa-val-server)

- Install the kuksa_viss_client. Follow [KUKSA_VISS_CLIENT](https://github.com/eclipse/kuksa.val/tree/master/kuksa_viss_client)

- Connect to server, authorize.

- Create a config.YAML file.

- Create a file for Mapbox API.

- Update the path of both files in the source code. [here](https://github.com/hritik-chouhan/nav-app/blob/main/lib/config.dart#L25)

- Go to the project directory

- First run flutter create .

- Then to run the app flutter run
