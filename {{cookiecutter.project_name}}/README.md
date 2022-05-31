{{cookiecutter.project_name}} is a [django](https://github.com/django/django) project flake configured with the use of [digga](https://github.com/divnix/digga).

# Initial setup

1. Run `direnv allow` to activate development environment.
2. Build an image in the DigitalOcean format with `nixos-generate --flake '.#do' --format do`.
3. [Upload the image](https://docs.digitalocean.com/products/images/custom-images/how-to/upload/) to DigitalOcean, name it `nixos.qcow2.gz`.
4. [Configure](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs) DigitalOcean terraform provider.
5. Initialize (`terraform init`) and apply (`terraform apply`) terraform config from the `terraform/` directory.
6. [Setup DNS](https://docs.digitalocean.com/tutorials/dns-registrars/), create following `NS` records.
```
ns1.digitalocean.com
ns2.digitalocean.com
ns3.digitalocean.com
```

# CI

This project uses GitHub Actions for CI/CD pipelines. 

1. [Create a repo on GitHub](https://docs.github.com/en/get-started/quickstart/create-a-repo).
2. [Create following secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository) for your repo.
  * `SSH_PRIVATE_KEY` - private key corresponding to the public key supplied on initialization
  * `SSH_KNOWN_HOSTS` - result of `ssh-keyscan {{cookiecutter.domain_name}}`
3. Tag a commit and push it to trigger update.

# Development

Execute `bud vm dev` from the top level directory to generate & run a one-shot vm. You can access it with `ssh nixos@localhost -p 2221`. You can access the web service on `https://localhost:8080`.

Run `direnv allow` inside `pkgs/{{cookiecutter.project_name}}` to activate django development environment.
