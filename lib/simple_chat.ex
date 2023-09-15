defmodule SimpleChat do
  def start do
    # Create Agent processes for User1 and User2
    {:ok, pid_1} = Agent.start_link(fn -> [] end)
    {:ok, pid_2} = Agent.start_link(fn -> [] end)
    # Simulate a chat between User1 and User2
    send_message(pid_1, pid_2, "User1", "Hello, User2!")
    send_message(pid_2, pid_1, "User2", "Hi, User1!")

    # simulating seeing hostory
    get_histories([pid_1, pid_2])
  end

  def send_message(pid_1, pid_2, sender, message) do
     timestamp = DateTime.utc_now()
    Agent.update(pid_1, fn history -> add_message(history, sender, message, timestamp)  end)
    Agent.update(pid_2, fn history ->add_message(history, sender, message, timestamp)  end)

    # Display the message
    IO.puts("#{sender}: #{message}")
  end

  def add_message(history, sender, message, timestamp) do
     [%{sender: sender, message: message, timestamp: timestamp} | history]
  end

  def get_histories(pids) do
    Enum.map(pids, fn pid -> history(pid) end)
  end

  def history(pid) do
     Agent.get(pid, fn history -> history end)
  end
end
