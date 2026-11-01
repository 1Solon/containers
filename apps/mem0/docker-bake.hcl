target "docker-metadata-action" {}

variable "VERSION" {
  // The server ships in the mem0ai monorepo; its vX.Y.Z tags match the PyPI release.
  // renovate: datasource=pypi depName=mem0ai
  default = "2.2.1"
}

variable "SOURCE" {
  default = "https://github.com/mem0ai/mem0"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
  }
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
  }
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
