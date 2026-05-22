/*
  # Seed Demo Data

  ## Summary
  Inserts demo trailers and customers for development.
  Auth users must be created via Supabase Auth UI / API separately,
  but profiles will be auto-created on first login via trigger.

  ## Trigger
  - Creates a trigger to auto-create a profile row when a new auth user is created.

  ## Demo Trailers
  - 3 sample trailers with different statuses for testing.

  ## Demo Customers
  - 3 sample customers for rental form auto-fill.
*/

-- Auto-create profile on new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, email, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE(NEW.email, ''),
    COALESCE(NEW.raw_user_meta_data->>'role', 'member')
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- Sample trailers (no created_by since no auth user yet)
INSERT INTO trailers (id, name, license_plate, description, created_at)
VALUES
  (gen_random_uuid(), 'Anhänger A1', 'M-AH 1001', 'Einachsiger Pkw-Anhänger, 750 kg, 2x1m Ladefläche', now()),
  (gen_random_uuid(), 'Tieflader TL1', 'M-TL 2002', 'Tieflader für schwere Maschinen, 3500 kg, 4x2m', now()),
  (gen_random_uuid(), 'Kastenanhänger K2', 'M-KA 3003', 'Kastenanhänger mit Plane, 1500 kg, ideal für Umzüge', now())
ON CONFLICT DO NOTHING;

-- Sample customers
INSERT INTO customers (id, full_name, email, phone, address, created_at)
VALUES
  (gen_random_uuid(), 'Max Mustermann', 'max@mustermann.de', '+49 89 12345678', 'Musterstraße 1, 80331 München', now()),
  (gen_random_uuid(), 'Anna Schmidt', 'anna.schmidt@gmail.com', '+49 176 98765432', 'Hauptstraße 42, 80335 München', now()),
  (gen_random_uuid(), 'Klaus Weber', 'k.weber@web.de', '+49 89 87654321', 'Gartenweg 7, 82031 Grünwald', now())
ON CONFLICT DO NOTHING;
