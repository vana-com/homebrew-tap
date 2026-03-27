class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.11.4-canary.ab31d23"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-interaction-api-redesign/vana-darwin-arm64.tar.gz"
      sha256 "5210d94b22823f3ed045cdf126c5def7fcb2ea0926cfccbd80403a32000bc833"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-interaction-api-redesign/vana-darwin-x64.tar.gz"
      sha256 "962d55350a2eab452d9d132fd6c99738094725920a82fdf7ffd41b716f112f82"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-interaction-api-redesign/vana-linux-x64.tar.gz"
    sha256 "00ce627fb9b7014fd9cfb8d23c7d608fa44201abef043acd0aaabd2596bcaa19"
  end

  def install
    payload_root =
      if (buildpath/"vana").exist? && (buildpath/"app").directory?
        buildpath
      else
        child = Dir.children(buildpath)
          .reject { |entry| entry.start_with?(".") }
          .find { |entry| File.directory?(buildpath/entry) }
        raise "Unable to locate Vana payload root" unless child

        buildpath/child
      end

    libexec.install payload_root/"app"
    libexec.install payload_root/"vana"
    (bin/"vana").write_env_script libexec/"vana", VANA_APP_ROOT: libexec/"app"
  end

  test do
    assert_match "runtime", shell_output("#{bin}/vana status --json")
  end
end
