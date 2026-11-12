{ config, ... }:
{
  # GitLab deploy token (read_registry) on boblehest/blog
  config.sops.secrets.gitlab-blog-registry-token = {};

  # Internet-facing apps: images built and pushed by GitLab CI, picked up by
  # podman auto-update. Add one with e.g.
  #   services.myapp = {
  #     image = "registry.gitlab.com/<you>/myapp:main";
  #     domain = "myapp.example.com";
  #     port = 8080;      # inside the container
  #     hostPort = 8001;  # unique per service
  #   };
  config.my.publicServices = {
    enable = true;
    acmeEmail = "jlode90@gmail.com";
    registryLogin = {
      username = "frodo";
      passwordFile = config.sops.secrets.gitlab-blog-registry-token.path;
    };
    services = {
      blog = {
        image = "registry.gitlab.com/boblehest/blog:main";
        domain = "blog.noand.no";
        port = 8080; # nginx-unprivileged
        hostPort = 8001;
      };
    };
  };
}
