namespace :admin_role do
  desc 'Grant admin privilege to user'
  task :grant, ['user_id'] => :environment do |task, args|
    user = User.find(args.user_id)
    if AdminRole.create(user: user)
      puts "grant admin privilege to user (user_id = #{args.user_id})"
    else
      puts 'failed to grant privilege'
    end
  end
end
