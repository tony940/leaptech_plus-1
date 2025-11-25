-- Test script for invited employees functionality
-- This script creates test data and verifies the invited employees feature

-- Insert test employees if they don't exist
INSERT INTO public.employees (id, full_name, email, phone, title, type, branch, image_url) 
VALUES 
('a1b2c3d4-e5f6-7890-1234-567890abcdef', 'Tony Stark', 'tony@starkindustries.com', '123-456-7890', 'CEO', 'Admin', 'Headquarters', 'https://example.com/tony.jpg'),
('f0e9d8c7-b6a5-4321-fedc-ba9876543210', 'Pepper Potts', 'pepper@starkindustries.com', '098-765-4321', 'COO', 'Admin', 'Headquarters', 'https://example.com/pepper.jpg'),
('123e4567-e89b-12d3-a456-426614174000', 'Happy Hogan', 'happy@starkindustries.com', '555-123-4567', 'Head of Security', 'Employee', 'Headquarters', 'https://example.com/happy.jpg')
ON CONFLICT (id) DO NOTHING;

-- Insert a test event if it doesn't exist
INSERT INTO public.events (id, organizer, name, about, event_time, duration, location) 
VALUES 
(1, 'a1b2c3d4-e5f6-7890-1234-567890abcdef', 'Board Meeting', 'Monthly board meeting discussion', '2025-12-01 10:00:00+00', 2.0, 'Conference Room A')
ON CONFLICT (id) DO NOTHING;

-- Insert event invitations if they don't exist
INSERT INTO public.event_invitations (event_id, employee_id) 
VALUES 
(1, 'a1b2c3d4-e5f6-7890-1234-567890abcdef'),  -- Tony invited to Board Meeting
(1, 'f0e9d8c7-b6a5-4321-fedc-ba9876543210'),  -- Pepper invited to Board Meeting
(1, '123e4567-e89b-12d3-a456-426614174000')   -- Happy invited to Board Meeting
ON CONFLICT DO NOTHING;

-- Query to verify invited employees for the event
-- This simulates what our getEventInvitedEmployees() function should return
SELECT 
    e.id as employee_id,
    e.full_name,
    e.image_url
FROM public.event_invitations ei
JOIN public.employees e ON ei.employee_id = e.id
WHERE ei.event_id = 1
ORDER BY e.full_name;

-- Query to verify all employees (for comparison)
SELECT 
    id as employee_id,
    full_name,
    image_url
FROM public.employees
ORDER BY full_name;