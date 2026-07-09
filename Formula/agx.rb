class Agx < Formula
  desc "agx — the CLI: one-shot sandboxed commands daemonless, and the front door to everything else"
  homepage "https://github.com/agx-runtime/agx"
  version "0.1.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://get.agx.so/v0.1.5/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "dbb268aa664fa4ec97fe4e33b544c6012d35134ba0e5583008ca2bf0861530eb"
    mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.5/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "dbb268aa664fa4ec97fe4e33b544c6012d35134ba0e5583008ca2bf0861530eb"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://get.agx.so/v0.1.5/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d392ca12862bd2fa4a3a5720e700448f7ae2c723377b90ea5632b045b8dcb875"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.5/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d392ca12862bd2fa4a3a5720e700448f7ae2c723377b90ea5632b045b8dcb875"
    end
    if Hardware::CPU.intel?
      url "https://get.agx.so/v0.1.5/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a6b9274330ee6b03fc55b074fbec8a50694988d8a78bfe9e5f56bf0e8a87ddb0"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.5/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a6b9274330ee6b03fc55b074fbec8a50694988d8a78bfe9e5f56bf0e8a87ddb0"
    end
  end
  license "AGPL-3.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "agx" if OS.mac? && Hardware::CPU.arm?
    bin.install "agx" if OS.linux? && Hardware::CPU.arm?
    bin.install "agx" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
