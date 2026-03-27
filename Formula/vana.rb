class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.11.4-canary.9ba0b7d"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-interaction-api-redesign/vana-darwin-arm64.tar.gz"
      sha256 "bd4bd95ce33e0c40bd892a55abaa0855a56741e656058d2f9339c3fe90dbd5a7"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-interaction-api-redesign/vana-darwin-x64.tar.gz"
      sha256 "5718f9bdb442bd50814af4b752985fb58ee841a340897841f01ee6c2d8bec8ce"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-interaction-api-redesign/vana-linux-x64.tar.gz"
    sha256 "7140b8ea6e73295122642ac0235101be5a28c7a5c996823bed5162daa921242d"
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
