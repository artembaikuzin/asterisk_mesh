module SupportHelper
  DIR = Dir.getwd
  SUPPORT = "#{DIR}/test/support"

  def yml_file(name)
    "#{SUPPORT}/#{name}"
  end
end
