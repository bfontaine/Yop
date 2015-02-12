# -*- coding: UTF-8 -*-

class File
  # Test if a file seems to be binary
  # adapted from http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/44936
  # @param path [String] the file's path
  # @return [Boolean] true if the file seems to be binary, false if not
  def self.binary?(path)
    st = lstat(path)
    if st.file? && st.size > 0
      blk = File.read(path, st.blksize)
      blk.count("\x00") > 0 ||
        blk.count("^ -~", "^\r\n") / blk.size > 0.3
    else
      false
    end
  end
end
