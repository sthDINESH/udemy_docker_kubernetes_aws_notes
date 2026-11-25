# MongoDB with Mongo Express

This project runs MongoDB together with Mongo Express on a Docker network.

- MongoDB stores data in the `mongo-database` named volume.
- Mongo Express provides a browser interface for managing MongoDB.
- Both containers use the `mongodb` Docker network.

## Start

```bash
chmod +x setup.sh
./setup.sh start
```

Open Mongo Express at <http://localhost:8081>.

## MongoDB credentials

- Username: `root`
- Password: `password123`
- Authentication database: `admin`

Mongo Express is configured with these credentials automatically. Unless basic authentication is added to the Mongo Express container, the browser page does not require a separate Mongo Express login.

## Stop

```bash
./setup.sh stop
```

This stops both containers and removes the Docker network. The `mongo-database` volume and all MongoDB data remain available.

Restart afterward with:

```bash
./setup.sh start
```

## Remove everything

```bash
./setup.sh remove
```

This stops and removes both containers, removes the Docker network, and deletes the `mongo-database` volume.

> **Warning:** Removing the volume permanently deletes all stored MongoDB data.
