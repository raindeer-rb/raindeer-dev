# frozen_string_literal: true

class Contributors < LowNode
  User = Data.define(:username, :avatar_id) do
    def avatar_url = "https://avatars.githubusercontent.com/u/#{avatar_id}"
    def profile_url = "https://github.com/#{username}"
  end

  def initialize
    @users = [
      User.new('maedi', 601650),
      User.new('Piyush-Goenka', 177754884),
      User.new('obsidiannnn', 219598893)
    ].freeze
  end

  def render
    <article id="contributors">
      <header>
        <h2>Contributors</h2>
      </header>

      <ul>
        <{ for: user in: @users }>
          <li>
            <a href="{user.profile_url}" data-tooltip="{user.username}">
              <img class="icon" alt="{user.username}" src="{user.avatar_url}"/>
            </a>
          </li>
        <{ :for }>
      </ul>

      <footer>
        <a href="/docs/contributing" role="button"><i class="bi bi-code-square"></i>Contribute</a>
      </footer>
    </article>
  end
end
