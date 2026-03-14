class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.8.1-canary.9939464"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-darwin-arm64.tar.gz"
      sha256 "7642248a7fd3306311c0f694dd2469f7b5ff57a237d9336168113dc97ed57eda"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-darwin-x64.tar.gz"
      sha256 "b9b3d7c9ef24f82a1c7e51be095fb1c27863c5f0d43baded5f36955b89b0c695"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-linux-x64.tar.gz"
    sha256 "309d2d2dd3f9cf91dccf5cb29addc4bb1fb6122b39b2ae0804f96b8b59ff4373"
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
