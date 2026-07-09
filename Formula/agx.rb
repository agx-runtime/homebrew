class Agx < Formula
  desc "agx — the CLI: one-shot sandboxed commands daemonless, and the front door to everything else"
  homepage "https://github.com/agx-runtime/agx"
  version "0.1.8"
  if OS.mac? && Hardware::CPU.arm?
    url "https://get.agx.so/v0.1.8/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "95de7544a06cea61f6a37247eb615c9fd0b0f800c5b9d9d9c35c922da8149827"
    mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.8/agx-cli-aarch64-apple-darwin.tar.xz"
    sha256 "95de7544a06cea61f6a37247eb615c9fd0b0f800c5b9d9d9c35c922da8149827"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://get.agx.so/v0.1.8/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d69e311240b62905f69839310d2066da055c8035ecb350bd0cafb6d8170bcd4d"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.8/agx-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d69e311240b62905f69839310d2066da055c8035ecb350bd0cafb6d8170bcd4d"
    end
    if Hardware::CPU.intel?
      url "https://get.agx.so/v0.1.8/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f08355f1f1b0c49a00ab6c51040154ac3c88e2b5fab5e6319807c6531b2922a8"
      mirror "https://github.com/agx-runtime/agx/releases/download/v0.1.8/agx-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f08355f1f1b0c49a00ab6c51040154ac3c88e2b5fab5e6319807c6531b2922a8"
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
