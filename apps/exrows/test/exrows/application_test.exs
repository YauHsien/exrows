defmodule Exrows.ApplicationTest do
  use ExUnit.Case, async: true

  test "application start" do
    :ok = Application.ensure_started(:exrows)
    Phoenix.PubSub.subscribe(:event_stream, "hello")
    Phoenix.PubSub.broadcast(:event_stream, "hello", {:hello,:world})
    assert {:messages, [hello: :world]} == Process.info(self(), :messages)
    Application.stop(:exrows)
  end
end
