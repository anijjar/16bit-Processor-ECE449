LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FETCH_CONTROLLER IS
   GENERIC (
      N : INTEGER := 16;
      ram_address_length : integer := 10
   );
   PORT (
      clk : in std_logic; -- reset and run instructions
      rst : in std_logic;
      rst_ex : in std_logic; -- reset and run instructions
      rst_ld : in std_logic; -- reset and load instructions
      out_output : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      -- RAM port B (read only)
      in_ram_data : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
      out_ram_addrb : OUT STD_LOGIC_VECTOR(ram_address_length-1 DOWNTO 0);
      out_ram_enb   : OUT STD_LOGIC;
      out_ram_rstb   : out std_logic;
        -- rom port
      in_rom_data    : in std_logic_vector(15 downto 0);
      out_rom_rd_en  : out std_logic;
      out_rom_adr    : out std_logic_vector(ram_address_length-1 downto 0);  
      out_rom_rst    : out std_logic;
      out_rom_rd     : out std_logic; --dont use
      -- PC
      in_pc : in std_logic_vector(N-1 downto 0);
      out_pc_rst : out std_logic;
      out_pc : out std_logic_vector(N-1 downto 0)
   );
END FETCH_CONTROLLER;

ARCHITECTURE level_2 OF FETCH_CONTROLLER IS
    signal signal_out_pc : std_logic_vector(N-1 downto 0) := (others => '0');
BEGIN
    process(clk, rst, rst_ex, rst_ld, in_ram_data, in_rom_data, in_pc)
    variable prog_en : integer := 0;
    begin
    if(rst_ld = '1') then --on rst_load
        signal_out_pc <= x"0002";
        out_pc_rst <= '1';
        prog_en := 1;
        out_ram_addrb <= (others => '0');
        out_ram_enb   <= '0';
        out_ram_rstb  <= '1';
        -- rom port
        out_rom_rd_en  <= '0';
        out_rom_adr    <= (others => '0');
        out_rom_rst  <= '1';
    elsif(rst_ex = '1') then -- on rst_ex
        signal_out_pc <= X"0000";
        out_pc_rst <= '1';
        prog_en := 1;
        out_ram_addrb <= (others => '0');
        out_ram_enb   <= '0';
        out_ram_rstb  <= '1';
        -- rom port
        out_rom_rd_en  <= '0';
        out_rom_adr    <= (others => '0');
        out_rom_rst  <= '1';
    else -- everytime else
        out_pc_rst <= '0';
        if(prog_en = 2) then
            if(in_pc < X"03FF") then
                out_rom_rd_en <= '1';   
                out_rom_rst <= '0';
                out_rom_adr <= '0' & in_pc(ram_address_length-1 downto 1);
                --set ram at the same time
                out_ram_addrb <= "00"&X"00";
                out_ram_enb <= '0';
                out_ram_rstb <= '1'; 
                out_output <= in_rom_data;
            else
                out_ram_enb <= '1';
                out_ram_rstb <= '0';
                out_ram_addrb <= '0' & in_pc(ram_address_length-1 downto 1);
                out_rom_rd_en <= '0';    
                out_rom_rst <= '1';
                out_rom_adr <= "00"&X"00";
                out_output <= in_ram_data;
            end if;
        else 
            prog_en := 2;
        end if;
    end if;
    end process;
    out_pc <= signal_out_pc;
--    PROCESS(clk, rst, rst_ex, rst_ld, in_ram_data, in_pc)
--    variable prog_en : integer := 0;
--    BEGIN
--    -- reset deletes everything from rom/ram
--    if(rst = '1') then
--        out_ram_addrb <= (others => '0');
--        out_ram_enb   <= '0';
--        out_ram_rstb  <= '1';
--        -- rom port
--        out_rom_rd_en  <= '0';
--        out_rom_adr    <= (others => '0');
--        out_rom_rst  <= '1';
--    else
--        if(rst_ex = '1') then
--            prog_en := 1;
--            signal_out_pc <= x"0000";
--            out_pc_rst <= '1';
--        elsif(rst_ld = '1') then
--            prog_en := 1;
--            signal_out_pc <= x"0002";
--            out_pc_rst <= '1';
--        else
--            out_pc_rst <= '0';
--        end if;
--        if((rst_ex = '0' or rst_ld = '0') AND (prog_en = 1 or prog_en = 2)) then
--            if(in_pc < X"03FF" AND prog_en = 2) then
--                out_rom_rd_en <= '1';   
--                out_rom_rst <= '0';
--                out_rom_adr <= '0' & in_pc(ram_address_length-1 downto 1);
                
--                --set ram at the same time
--                out_ram_addrb <= "00"&X"00";
--                out_ram_enb <= '0';
--                out_ram_rstb <= '1'; 
                
--                out_output <= in_rom_data;
--            elsif (prog_en = 2) then
--                out_ram_enb <= '1';
--                out_ram_rstb <= '0';
--                out_ram_addrb <= '0' & in_pc(ram_address_length-1 downto 1);
                
--                out_rom_rd_en <= '0';    
--                out_rom_rst <= '1';
--                out_rom_adr <= "00"&X"00";
                
--                out_output <= in_ram_data;
--            else
--                prog_en := 2;
--                out_rom_rst <= '0';
--                out_ram_rstb <= '0';
--            end if;
--        else
--            out_ram_enb <= '0';
--            out_rom_rd_en <= '0';
--            out_rom_rst <= '0';
--            out_ram_rstb <= '0';
--        end if;
--    end if;
--    END PROCESS;
--    out_pc <= signal_out_pc;
END level_2;