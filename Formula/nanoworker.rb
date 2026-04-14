class Nanoworker < Formula
  desc "Nanomite distributed worker agent"
  homepage "https://github.com/nanomiteai/nanoworker"
  license :cannot_represent
  version "0.1.5"

  on_macos do
    url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.5/nanoworker_darwin_arm64.tar.gz"
    sha256 "d571f8fcb9867f71bd7c5b8392d82974728129c0a7c4badc6cf07b3ed76c6e23"
  end

  on_linux do
    on_arm do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.5/nanoworker_linux_arm64.tar.gz"
      sha256 "c5b1549a64ab95a3f995b769ff8057f63a1fdb070d96b7883055cadcbca922c8"
    end
    on_intel do
      url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.5/nanoworker_linux_amd64.tar.gz"
      sha256 "a5298e259c8a8c8e74d29560a6b493680f94dfa94cd76ae70f917e599061f2be"
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
