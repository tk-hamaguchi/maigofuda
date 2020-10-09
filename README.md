# 迷子札 [Maigofuda]

[![codecov](https://codecov.io/gh/tk-hamaguchi/maigofuda/branch/master/graph/badge.svg)](https://codecov.io/gh/tk-hamaguchi/maigofuda)
[![CircleCI](https://circleci.com/gh/tk-hamaguchi/maigofuda/tree/master.svg?style=shield)](https://circleci.com/gh/tk-hamaguchi/maigofuda/tree/master)


Rails' error handling more easy!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'maigofuda'
```

And then execute:
```bash
$ bundle
```

Next, you need to run the generator:

```ruby
$ rails generate maigofuda:install
```

## Usage

1. Create extended error class from status code.

    | status code |             error class             |
    |:-----------:|:----------------------------------- |
    |     401     | Maigofuda::UnauthorizedError        |
    |     422     | Maigofuda::UnprocessableEntityError |

    ex.
    ```ruby
    class UserUnauthorized < Maigofuda::UnauthorizedError
    end
    ```

2. Execute `rake maigofuda:rebuild`
3. Edit `config/error_codes.yml` and append your class' error code.
    ex.
    ```yaml
    UserUnauthorized: U12345
    ```

That's all.

If you raise UserUnauthorized at some action, The error is caught by Maigofuda::ErrorHandler then render json response.

```json
{"errors":"YOUR-RAISED-MESSAGE"}
```

And this is accompanied by the output to the log.

```txt
<U12345> UserUnauthorized  YOUR-RAISED-MESSAGE
```

### Customize response body

If you are not happy with the default response body, you can customize it as below:

```ruby
class UserUnauthorized < Maigofuda::UnauthorizedError
  attr_accessor :special_text

  def attributes
    super.merge(special_text: special_text)
  end
end
```

On the other hand, if you want to customize for all errors, you can inject the class as shown below.

```ruby
class YourCustomError < Maigofuda::BaseError
  attr_accessor :special_text

  def attributes
    super.mege(special_text: special_text)
  end
end
```

Then change config (`config/initializers/maigofuda.rb`) below:
```ruby
Maigofuda.setup do |config|
  # ...

  config.injection_error_class = 'YourCustomError'

  # ...
end
```

### Customize log message

You can override log message methods.

```ruby
class ApplicationController < ActionController::Base

#...

  def log_prefix(error)
    "YOUR_MESSAGE_PREFIX"
  end

  def log_suffix(error)
    "YOUR_MESSAGE_SUFFIX"
  end

  def log_message(error)
    "message:#{error.message}"
  end

#...

end
```

```txt
<U12345> UserUnauthorized  YOUR_MESSAGE_PREFIX  message:YOUR-RAISED-MESSAGE  YOUR_MESSAGE_SUFFIX
```

If you hide error code or class name, you can change config (`config/initializers/maigofuda.rb`) below:

```ruby
Maigofuda.setup do |config|

  #...

  config.print_error_code = false

  config.print_error_class = false

  #...
```

### Hook log event

You can set hooks for log event.  Inside the Hook you can access the error object using `maigofuda_error`.

```ruby
class ApplicationController < ActionController::Base

#...

  before_maigofuda :hoge
  after_maigofuda  :fuga
  around_maigofuda :puki

  def hoge
    Rails.logger.debug 'hoge'
    Rails.logger.debug maigofuda_error.message
  end

  def fuga
    Rails.logger.debug 'fuga'
  end

  def puki
    Rails.logger.debug 'puki_before'
    yield
    Rails.logger.debug 'puki_after'
  rescue => e
    Rails.logger.debug 'puki_rescue'
    raise e
  ensure
    Rails.logger.debug 'puki_ensure'
  end

#...
```

### Disable auto include

Maigofuda automatically includes Maigofuda::ErrorHandler and appends `rescue_from` to ActionController::Base and ActionController::API.  If you want to disable this function,  you change config and append manual include.

```ruby
Maigofuda.setup do |config|

  #...

  config.auto_load = false

  #...
```

```ruby
class HogesController < ApplicationController

  #...

  include Maigofuda::ErrorHandler

  rescue_from Maigofuda::BaseError, with: :maigofuda

  #...
```



## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
