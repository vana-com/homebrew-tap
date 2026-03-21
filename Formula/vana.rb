class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.9.4-canary.888d13a"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cloud-ps-api/vana-darwin-arm64.tar.gz"
      sha256 "86822f2e49bede7dbc8bac8329ea0ec11d25d321e927b6027d880b4685dc46f6"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cloud-ps-api/vana-darwin-x64.tar.gz"
      sha256 "b0edda13beae0806e540f8f095f58a35ad8167f02ecf877531d02e3489460fe3"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cloud-ps-api/vana-linux-x64.tar.gz"
    sha256 "bf813a11234a69c9cf9d344e9e2a01c8777d1336794482b273ec37f4aeb84634"
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
