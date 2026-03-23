class Vana < Formula
  desc "Vana Connect CLI"
  homepage "https://github.com/vana-com/vana-connect"
  version "0.10.1-canary.2898948"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-darwin-arm64.tar.gz"
      sha256 "5eec9fb4d72c6453eea7944ce9581593a8cc85d0e2e607d92b63a4f64672f8cd"
    else
      url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-darwin-x64.tar.gz"
      sha256 "8adff02f775632ec70ba49d7455eb1ffb8031a0602969760ce9905716cb70d19"
    end
  end

  on_linux do
    url "https://github.com/vana-com/vana-connect/releases/download/canary-feat-cli-auth/vana-linux-x64.tar.gz"
    sha256 "db042d5994dd68e5f6b72541d4c5c1229cf3979726775648a98ac5a2ec9191b7"
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
