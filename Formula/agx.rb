class Agx < Formula
  desc "agx — the CLI: one-shot sandboxed commands daemonless, and the front door to everything else"
  homepage "https://github.com/agx-runtime/agx"
  version "0.1.7"
  if OS.mac? && Hardware::CPU.arm?
    url "https://get.agx.so/v0.1.7/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "3c10c69a869cd9630c024920bb64afd5112508babc6562fca61639312293135e"
    mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.7/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "3c10c69a869cd9630c024920bb64afd5112508babc6562fca61639312293135e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://get.agx.so/v0.1.7/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "421b909df346e36213509569cd922a8afece5951fb357b1cfce5d41793eb8959"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.7/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "421b909df346e36213509569cd922a8afece5951fb357b1cfce5d41793eb8959"
    end
    if Hardware::CPU.intel?
      url "https://get.agx.so/v0.1.7/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ddd4d061ae6ae25f35756fa26519e9fe1c9bcc763e10153476e41b83dbfce6df"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.7/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ddd4d061ae6ae25f35756fa26519e9fe1c9bcc763e10153476e41b83dbfce6df"
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
