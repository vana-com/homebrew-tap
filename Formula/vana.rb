class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.8.1-canary.153756e"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-darwin-arm64.tar.gz"
      sha256 "33583c5f3bc6fed4e5de476dfd0bae7c1381a778f5b7aa2de0dec8f883ccac34"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-darwin-x64.tar.gz"
      sha256 "f7aeff029e341ff23397279922ce39df53a039aae37d56a91ec11770e856e8c5"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-connect-cli-v1/vana-linux-x64.tar.gz"
    sha256 "c807ffb6db7d1394e8285d5d47136274708bd1e797ef0858a23e8324d159db1a"
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
