class Nanoworker < Formula
  desc "Nanomite distributed worker agent"
  homepage "https://github.com/nanomiteai/nanoworker"
  license :cannot_represent
  version "0.1.1"

  on_macos do
    url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.1/nanoworker_darwin_arm64.tar.gz"
    sha256 "c0532e8f3b4b3e28ce68136e01b70b2807db169bf9896f71a59db1bb8a10cfb7"
  end

  on_linux do
    url "https://github.com/nanomiteai/nanoworker/releases/download/v0.1.1/nanoworker_linux_arm64.tar.gz"
    sha256 "a6c10f2d034b298661d935c75b695de9de7aca0f39791a0c54157b04e2efd5bf"
  end

  def install
    bin.install "nanoworker"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanoworker version")
  end
end
