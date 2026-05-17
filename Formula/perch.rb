class Perch < Formula
  desc "A real-time terminal dashboard for git changes"
  homepage "https://github.com/upsertco/perch"
  version "1.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/upsertco/perch/releases/download/v1.5.0/perch-aarch64-apple-darwin.tar.xz"
      sha256 "7d34bbcd0da8a96579e4898f2a1f74f17c991738dc72245b608398b7bedc6a8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/upsertco/perch/releases/download/v1.5.0/perch-x86_64-apple-darwin.tar.xz"
      sha256 "e201db1318686fc3625a6ae90180f5409de4eec74c619cdac7f4c9db1d8dfcd3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/upsertco/perch/releases/download/v1.5.0/perch-aarch64-unknown-linux-musl.tar.xz"
      sha256 "225fc39e8999ed3675d8c7bb96979857ea658d772b186ec9cef894be668516db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/upsertco/perch/releases/download/v1.5.0/perch-x86_64-unknown-linux-musl.tar.xz"
      sha256 "09de83a17f436b185460180064b09fa205169a0a2b7fc93b4dd071329f941a09"
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
