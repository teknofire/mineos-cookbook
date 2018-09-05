module MineosCookbook
  module Helpers
    def platform_service_name
      'mineos.service'
    end

    def install_path
      '/usr/games/minecraft'
    end

    def mineos_service_obj
      find_resource(:service, platform_service_name) do |new_resource|
        service_name lazy { platform_service_name }
        supports restart: true, status: true, reload: true
        action :nothing
      end
    end
  end
end
