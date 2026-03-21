class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.10.0-canary.e8aeb13"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-darwin-arm64.tar.gz"
      sha256 "46f056e6bab50c34b8ccafce5e345cea20afd84830923acf44a56d4d7ffb44b3"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-darwin-x64.tar.gz"
      sha256 "119d8522ba3eeeec89d0daaa0c470db7b1756e46a35168e7be6eac57d42bb20c"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-linux-x64.tar.gz"
    sha256 "183775296609d25732fafd1bfcc7927432c2e3dd39224fee83ea003adcd791b4"
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
