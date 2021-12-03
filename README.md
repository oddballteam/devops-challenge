### Steps:

1. Deploy the ECR from `terraform/bootstrap` to have a place to push images to. May want to add outputs here.
1. Build the image in `app`. An engineer was trying to create a file "version.txt" that is exposed via an endpoint, it worked for them locally, when they created the file, but they are struggling to make it work when the Docker image is built.
1. Push images to the new ECR repos.
1. Deploy the ECS from `terraform/app`, debugging as necessary.
1. Add listener for HTTPS on port 443, and add rule to send traffic to ECS target group.
