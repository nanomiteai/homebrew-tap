class Nanoworker < Formula
  desc "Nanomite distributed worker agent"
  homepage "https://github.com/nanomiteai/nanoworker"
  license :cannot_represent
  version "0.1.4"

  on_macos do
    url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.4/nanoworker_darwin_arm64.tar.gz"
    sha256 "2ba9d3e23b64d7a83d5e22dae718bdf54d3eacb7999c3443e9659e24a2334301"
  end

  on_linux do
    on_arm do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.4/nanoworker_linux_arm64.tar.gz"
      sha256 "eaf4daf6ac4305464a1faac49b11ade328e3d5a77e44fc97860e4d517289c004"
    end
    on_intel do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.4/nanoworker_linux_amd64.tar.gz"
      sha256 "0e82c1af256b9e6e2b28eb462fa2019c3a13cd7773f3a9220d358f34061ea036"
    end
  end

  def install
    bin.install "nanoworker"
    (etc/"nanomite").install "nanomite.yaml.sample"
  end

  def post_install
    (var/"log/nanomite").mkpath
  end

  service do
    run [opt_bin/"nanoworker", "run"]
    keep_alive true
    log_path var/"log/nanomite/nanoworker.log"
    error_log_path var/"log/nanomite/nanoworker.log"
    working_dir var
  end

  def caveats
    <<~EOS
      To get started:

      1. Copy the sample config and edit it:
         mkdir -p ~/.config/nanomite
         cp #{etc}/nanomite/nanomite.yaml.sample ~/.config/nanomite/nanomite.yaml
         chmod 600 ~/.config/nanomite/nanomite.yaml

      2. Set your worker token (get it from the nanoweb UI under Workers):
         nanoworker token set <your-worker-token>

      3. Start the service:
         brew services start nanoworker

      Logs: #{var}/log/nanomite/nanoworker.log
      Config: ~/.config/nanomite/nanomite.yaml
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanoworker version")
  end
end
