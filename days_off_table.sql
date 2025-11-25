-- Create the days_off table with proper relations to employees
CREATE TABLE public.days_off (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  employee_id uuid NOT NULL,
  leave_type text NOT NULL CHECK (leave_type IN ('Sick', 'Personal', 'Annual')),
  start_date date NOT NULL,
  end_date date NOT NULL,
  description text,
  status text NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected')),
  attachment_url text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT days_off_pkey PRIMARY KEY (id),
  CONSTRAINT days_off_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE
);

-- Create indexes for better query performance
CREATE INDEX idx_days_off_employee_id ON public.days_off(employee_id);
CREATE INDEX idx_days_off_status ON public.days_off(status);
CREATE INDEX idx_days_off_leave_type ON public.days_off(leave_type);
CREATE INDEX idx_days_off_dates ON public.days_off(start_date, end_date);