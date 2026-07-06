class Agx < Formula
  desc "agx — the CLI: one-shot sandboxed commands daemonless, and the front door to everything else"
  homepage "https://github.com/agx-runtime/agx"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://get.agx.so/v0.1.0/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "77beab2495668309b0477a1d776b90a933ded822f192538e3c19582c75cb51da"
    mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.0/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "77beab2495668309b0477a1d776b90a933ded822f192538e3c19582c75cb51da"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://get.agx.so/v0.1.0/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8bd6302438115123047d257bffa5687f1b02bb317bbfe0186e81c3514527261d"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.0/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8bd6302438115123047d257bffa5687f1b02bb317bbfe0186e81c3514527261d"
    end
    if Hardware::CPU.intel?
      url "https://get.agx.so/v0.1.0/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fb7e912be93d94cd7488f58bcaa0db4a166147f1e4c698515bdf4886c7aa3ff2"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.0/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fb7e912be93d94cd7488f58bcaa0db4a166147f1e4c698515bdf4886c7aa3ff2"
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
