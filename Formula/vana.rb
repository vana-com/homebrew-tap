class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.8.1-canary.59211c8"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-darwin-arm64.tar.gz"
      sha256 "4696d409d2252cb80ed4ad502f4d00fe0a900793bd7c362f36bb3d0bfd26d73e"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-darwin-x64.tar.gz"
      sha256 "a711a1d6ae5b7d65cff0aedc4eedad417ce8b014bd5030c099b84fc0f91a7c5d"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-linux-x64.tar.gz"
    sha256 "ee44956a327d9f82f25d3901375323b2bf86e58e1d76a91eafccfe80f74c9f6e"
  end

  def install
    payload_root = Dir.children(buildpath)
      .reject { |entry| entry.start_with?(".") }
      .find { |entry| File.directory?(buildpath/entry) } || "."

    libexec.install (buildpath/payload_root/"app")
    libexec.install (buildpath/payload_root/"vana")
    (bin/"vana").write_env_script libexec/"vana", VANA_APP_ROOT: libexec/"app"
  end

  test do
    assert_match "runtime", shell_output("#{bin}/vana status --json")
  end
end
