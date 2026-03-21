class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.10.0-canary.0f04943"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-darwin-arm64.tar.gz"
      sha256 "0aba47f75745de272a7c3c1b2f7f946f92f705c3a13f3f8532a9f814d27bbe34"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-darwin-x64.tar.gz"
      sha256 "4b7a51a20d3a1cf0c0ee6a9a277678b8237a8cbc2acf0c8289b9cb66763db676"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-linux-x64.tar.gz"
    sha256 "b516d78b9b503528e72a1bc8358c8c74f2b48f30f6a0085aaf3c77dfc48fe803"
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
