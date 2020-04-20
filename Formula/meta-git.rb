require "language/node"

class MetaGit < Formula
  version = "2.2.12"

  desc "tool for turning many repos into a meta repo. why choose many repos or a monolithic repo, when you can have both with a meta repo?"
  homepage "https://github.com/mateodelnorte/meta"
  url "https://github.com/mateodelnorte/meta/archive/v#{version}.tar.gz"
  sha256 "791a33bf6df7025b0cd0e06de2a66e29830ceb8fa2cd492cf8ab2a115d95d146"

  depends_on "node"

  def install
    # Project appears to use git tags to determine the project version, which
    # breaks the version for installs from the tar.
    #
    # This is an attempt to manually set the version based on the version of
    # the tar fetched.
    package_json = "package.json"
    new_content = File.open(package_json) do |f|
      f.read.gsub(/0.0.0-development/, version)
    end
    IO.write(package_json, new_content)

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"meta", "init"
    system bin/"meta", "project", "create", "meta", "https://github.com/mateodelnorte/meta.git"
  end
end
