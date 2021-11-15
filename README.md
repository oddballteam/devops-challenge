### Steps:
1. Deploy the ECR from `terraform/bootstrap` to have a place to push images to. May want to add outputs here.
1. Build images (app, Nginx) -- which will require some debugging. Push images to the new ECR repos.
1. Deploy the ECS from `terraform/app`, debugging as necessary.
1. Add listener for HTTPS on port 443, and add rule to send traffic to ECS target group.

