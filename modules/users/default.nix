{ ... }:

let
  keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCo8S/zPXFzqZglCpyEbi+5M3k5PjVaBNCTo6nJisW9G5QhNO9Sh1Phrxbe4tP63Ifaw+C34tT8KP+0bgQ7G8vX0V6gg9KNE6l7FSW+HUYfP9cjsGK/9u9ox9yjAnJirVgM9nbtAg09MCZhvjlTagcjqi/9LEZR1h3Xk1SQDoGL0bPdicN/FcuR8jAbBiyKUM71yd/3wlImF4mfz5vQmYPw59/IM6btwNDG1wpOymiM2L+gs1RRLWtf0o0Lu9NMqpgyEOHpSmAdFH/YKSJqICeyOK9VcTyKnHRRYj6QjVgWzwP4yrnfJ4+G7WCQCwRd7VzdqUNmJDBpODiDjjeTNhp1X4jEykwPHvZjn2nnuphukx1HtfYUVX1Rv/OoU58zaekxzgLMZ2y5QC0zrNIEJlk+ILN7rkOQfY964Qoqa07NpAIeiCGOmBUEHygE4FFRFq8aN/1VYJ95CRhvR4H+ZMdQgrI5ukt+P7fBvCv0W9LXQ7LHbLDZJ0CuD5Q44QtR4zyMzo2/OggrzVXFQDSxvoz0Bt5OWtLrWuAKld25+dpjJe/FNH1oZCXBtfn8j4B1GejCDVQsssicbap2Cv46KJae6sXrVhwx9i5US8OiRWj/COb+pa0EVjVrBYEZNnHdjf/oo+mIFmZx+9CyqCQpmTuty2eNMStzPs5jP5yBh43buw=="
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5Tfy1sEhHv248HY+oZBADOQNryR+k1EEsDxyFjA0hdpFcL16WPmt1qfhKcVbpJrzPdLSjYVkC8bb8atIPQx5Cow48CiOpklQYGz8378Ytt3hsG5IcnC1lD8NsvDIZEdfZ5TjfcD0B1ZIGzZ7BzR2NldMxYUady/gRW9fEt41cm0+zyjaU2JUVuWpP9xI9FKc2euMtrfHfgi9Y+wOmMGjz3Urlx9a5Xemc04kxw5+bv6EzgHpCPwTTfg2WneKTP4A76czewdCoGoFWEZgSOzXG9GLwJASsz7pzrgtRrDeZd2+yrb9k9rXSN8NkfJgT7IU+J3n8TCfDyr9T7nW6OwJAr13uQKVAwYYewqm4pggNU1bgdklToQUkc2z3LjIcsEmAiwky46/3k4RXvwcnwrPZScwjRJZgigSwdwWbF84NOP2e+PvCJiwbPNQBVrakpZ36MPgH6BrVgU1NZaGPnN/+//JajVd9jkl6BpPZq+Tp6nyUCrDETzg3UrNK/Z16yhDrD6iQAaOGcnYE60ka56EhQV0cVPfwcOImvhj6W39z8nbMYfKN7BnEE5yVWVtgDcY/TJJMF9oO4OMTHma/LBhSkZjnXbvFooqgKytN9y+VE8PtYw8Eteuf3x9p8ePAzDkft66i8SViNKxAvTq4JfRbflnwVelE09fD8DOUIYWxGQ=="
  ];
in
{
  users = {
    mutableUsers = false;
    users.user = {
      description = "User";
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = keys;
    };
    users.root.openssh.authorizedKeys.keys = keys;
  };
}
