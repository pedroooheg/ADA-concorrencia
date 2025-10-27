-- Exemplo 1: Task simples
task type Worker is
   entry Start;
end Worker;

task body Worker is
begin
   accept Start; -- espera pelo rendezvous
   -- trabalho concorrente
end Worker;

W : Worker; -- instancia
-- Em outro lugar: W.Start; -- faz o rendezvous


-- Exemplo 2: Protected object para contador compartilhado
protected type Counter is
   procedure Increment;
   function Value return Integer;
private
   Count : Integer := 0;
end Counter;

protected body Counter is
   procedure Increment is
   begin
      Count := Count + 1;
   end Increment;

   function Value return Integer is
   begin
      return Count;
   end Value;
end Counter;

Shared_Cnt : Counter;


-- Exemplo 3: Event loop simplificado
task Event_Loop is
   entry Event_A;
   entry Event_B;
end Event_Loop;

task body Event_Loop is
begin
   loop
      select
         accept Event_A do
            -- tratar A
         end Event_A;
      or
         accept Event_B do
            -- tratar B
         end Event_B;
      end select;
   end loop;
end Event_Loop;


-- Exemplo 4: Producer/Consumer com rendezvous
task type Buffer is
   entry Put(Item : in Integer);
   entry Get(Item : out Integer);
end Buffer;

task body Buffer is
   Data : Integer;
   Full : Boolean := False;
begin
   loop
      select
         when not Full =>
            accept Put(Item : in Integer) do
               Data := Item;
               Full := True;
            end Put;
      or
         when Full =>
            accept Get(Item : out Integer) do
               Item := Data;
               Full := False;
            end Get;
      end select;
   end loop;
end Buffer;


-- Exemplo 5: Producer/Consumer com Protected Object
protected type PC_Buffer is
   entry Put(Item : in Integer);
   entry Get(Item : out Integer);
private
   Data : Integer;
   Full : Boolean := False;
end PC_Buffer;

protected body PC_Buffer is
   entry Put(Item : in Integer) when not Full is
   begin
      Data := Item;
      Full := True;
   end Put;

   entry Get(Item : out Integer) when Full is
   begin
      Item := Data;
      Full := False;
   end Get;
end PC_Buffer;

Shared : PC_Buffer;
