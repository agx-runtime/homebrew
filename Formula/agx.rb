class Agx < Formula
  desc "agx — the CLI: one-shot sandboxed commands daemonless, and the front door to everything else"
  homepage "https://github.com/agx-runtime/agx"
  version "0.1.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://get.agx.so/v0.1.2/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "61404df57b07c5d8ac307aab85b3af7638212d9358c69bd48200a28783d04546"
    mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.2/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "61404df57b07c5d8ac307aab85b3af7638212d9358c69bd48200a28783d04546"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://get.agx.so/v0.1.2/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5be727f6438db274dd43d4c19537fed353c9eb6b6924fc40a94e38b29d0af86e"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.2/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5be727f6438db274dd43d4c19537fed353c9eb6b6924fc40a94e38b29d0af86e"
    end
    if Hardware::CPU.intel?
      url "https://get.agx.so/v0.1.2/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5bcd81219f6e25a73df39f6019191483e2c96a3bf32e8d005ca0e7bec8f681a5"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.2/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5bcd81219f6e25a73df39f6019191483e2c96a3bf32e8d005ca0e7bec8f681a5"
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
