require "language/node"

class Mermaid < Formula
  desc "Generation of diagrams and flowcharts from text in a similar manner as markdown."
  homepage "http://knsv.github.io/mermaid/"
  url "https://registry.npmjs.org/mermaid/-/mermaid-6.0.0.tgz"
  sha256 "e0475783ede5863bd9a971d0d602979a41094f57dab6686b28219e8701abd7a6"
  head "https://github.com/knsv/mermaid.git"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.mermaid").write <<-EOS.undent
      graph TD;
        A-->B;
        A-->C;
        B-->D;
        C-->D;
    EOS

    #system bin/"mermaid", "test.mermaid"
    #assert File.file?("test.mermaid.png"), "output file not generated"
    require "open3"
    Open3.popen3(bin/"mermaid", "test.mermaid") do |stdin, stdout, stderr|
      puts stdout.read, stderr.read
    end
  end
end
