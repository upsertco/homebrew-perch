class Perch < Formula
  desc "A real-time terminal dashboard for git changes"
  homepage "https://github.com/upsertco/perch"
  version "1.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/upsertco/perch/releases/download/v1.6.0/perch-aarch64-apple-darwin.tar.xz"
      sha256 "ae0373f7506c1dee2be340d22ef2033be399353b04d33590efc0b398267a1316"
    end
    if Hardware::CPU.intel?
      url "https://github.com/upsertco/perch/releases/download/v1.6.0/perch-x86_64-apple-darwin.tar.xz"
      sha256 "6824f31b4375b4137668594029db6530a05524e0806714657b680e81cf1a4f13"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/upsertco/perch/releases/download/v1.6.0/perch-aarch64-unknown-linux-musl.tar.xz"
      sha256 "87957da4706cdf4d4b7aaba35337ca669f6e34f95aecf767707d902167f65d1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/upsertco/perch/releases/download/v1.6.0/perch-x86_64-unknown-linux-musl.tar.xz"
      sha256 "73eb623aab17758ac3533196063aa9f678afacc17a9caf4bb53832e8b7c7df37"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    bin.install "git-perch", "perch" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-perch", "perch" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-perch", "perch" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-perch", "perch" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
