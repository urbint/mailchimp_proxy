defmodule MailchimpProxyTest do
  use ExUnit.Case
  doctest MailchimpProxy

  test "greets the world" do
    assert MailchimpProxy.hello() == :world
  end
end
