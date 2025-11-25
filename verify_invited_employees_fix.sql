-- Verification script for invited employees functionality fix
-- This script verifies that the invited employees feature works correctly

-- First, let's clean up any existing test data
DELETE FROM public.event_invitations WHERE event_id = 999;
DELETE FROM public.events WHERE id = 999;
DELETE FROM public.employees WHERE id IN (
    '11111111-1111-1111-1111-111111111111',
    '22222222-2222-2222-2222-222222222222',
    '33333333-3333-3333-3333-333333333333'
);

-- Insert test employees
INSERT INTO public.employees (id, full_name, email, phone, title, type, branch, image_url) 
VALUES 
('11111111-1111-1111-1111-111111111111', 'Alice Johnson', 'alice@company.com', '111-111-1111', 'Developer', 'Employee', 'IT', 'https://example.com/alice.jpg'),
('22222222-2222-2222-2222-222222222222', 'Bob Smith', 'bob@company.com', '222-222-2222', 'Designer', 'Employee', 'Design', 'https://example.com/bob.jpg'),
('33333333-3333-3333-3333-333333333333', 'Carol Williams', 'carol@company.com', '333-333-3333', 'Manager', 'Admin', 'Management', NULL)
ON CONFLICT (id) DO NOTHING;

-- Insert a test event
INSERT INTO public.events (id, organizer, name, about, event_time, duration, location) 
VALUES 
(999, '11111111-1111-1111-1111-111111111111', 'Team Building Activity', 'Fun team building exercises', '2025-12-15 14:00:00+00', 3.5, 'Main Hall')
ON CONFLICT (id) DO NOTHING;

-- Insert event invitations
INSERT INTO public.event_invitations (event_id, employee_id) 
VALUES 
(999, '11111111-1111-1111-1111-111111111111'),  -- Alice invited
(999, '22222222-2222-2222-2222-222222222222')   -- Bob invited
-- Note: Carol is NOT invited to this event
ON CONFLICT DO NOTHING;

-- Query to verify invited employees for the event
-- This should return Alice and Bob, but NOT Carol
SELECT 
    e.id as employee_id,
    e.full_name,
    e.image_url
FROM public.event_invitations ei
JOIN public.employees e ON ei.employee_id = e.id
WHERE ei.event_id = 999
ORDER BY e.full_name;

-- Query to verify all employees (for comparison)
SELECT 
    id as employee_id,
    full_name,
    image_url
FROM public.employees
ORDER BY full_name;

-- Query to verify the event exists
SELECT 
    id,
    name,
    about,
    event_time,
    duration,
    location
FROM public.events
WHERE id = 999;