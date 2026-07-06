class Agx < Formula
  desc "agx — the CLI: one-shot sandboxed commands daemonless, and the front door to everything else"
  homepage "https://github.com/agx-runtime/agx"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://get.agx.so/v0.1.1/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "8a1bdf3d06c3a6f97b0b607ad02407f18c5f5ddb74019a7d457b64754d86b40b"
    mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.1/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "8a1bdf3d06c3a6f97b0b607ad02407f18c5f5ddb74019a7d457b64754d86b40b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://get.agx.so/v0.1.1/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1493b2f187619b116106eeb0782c28d3dd92cc077a9a576be1504523178d175b"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.1/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1493b2f187619b116106eeb0782c28d3dd92cc077a9a576be1504523178d175b"
    end
    if Hardware::CPU.intel?
      url "https://get.agx.so/v0.1.1/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "75763efdecf922f6cec02fe8b4adf08af988d71294a996bd50004dc797dc8097"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.1/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "75763efdecf922f6cec02fe8b4adf08af988d71294a996bd50004dc797dc8097"
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
