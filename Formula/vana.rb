class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.11.4-canary.3d6eb93"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-interaction-api-redesign/vana-darwin-arm64.tar.gz"
      sha256 "ba924fee9c1c20ef058eb87e2693bb5ccb67cf01f2e860d2833f152d3e23820f"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-interaction-api-redesign/vana-darwin-x64.tar.gz"
      sha256 "cc1fbce23ba36e2554d47b7d53fa2ce654221baf36bce2e2ad5e34a5fc419570"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-interaction-api-redesign/vana-linux-x64.tar.gz"
    sha256 "a86ab06c7326d9ee21e1d5c1b130adf181575aa6240ec638d368248c294967e7"
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
